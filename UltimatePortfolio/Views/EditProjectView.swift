//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 11/9/20.
//

import CloudKit
import SwiftUI
import CoreHaptics

struct EditProjectView: View {
    enum CloudStatus {
        case checking, exists, absent
    }

    @ObservedObject var project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false
    @State private var showingNotificationError = false
    @State private var remindMe: Bool
    @State private var reminderTime: Date

    @State private var hapticEngine = try? CHHapticEngine()

    @AppStorage("username") var username: String?
    @State private var showingSignIn = false
    @State private var cloudStatus = CloudStatus.checking
    @State private var cloudError: CloudError?

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)

        if let projectReminderTime = project.reminderTime {
            _reminderTime = State(wrappedValue: projectReminderTime)
            _remindMe = State(wrappedValue: true)
        } else {
            _reminderTime = State(wrappedValue: Date())
            _remindMe = State(wrappedValue: false)
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { colorName in
                        self.colorButton(for: colorName)
                    }
                }
                .padding(.vertical)
            }

            Section(header: Text("Project reminders")) {
                Toggle("Show reminders:", isOn: $remindMe.animation()
                    .onChange(update))
                .alert("Oops!", isPresented: $showingNotificationError) {
                    #if os(iOS)
                    Button("Check Settings", action: showAppSettings)
                    #endif
                    Button("OK") {}
                } message: {
                    Text("There was a problem. Please check that you have notifications enabled.")
                }

                if remindMe {
                    DatePicker("Reminder time",
                               selection: $reminderTime.onChange(update),
                               displayedComponents: .hourAndMinute)
                }
            }

            // swiftlint:disable:next line_length
            Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project entirely.")) {
                Button(project.closed ? "Reopen this project" : "Close this project", action: toggleClosed)

                Button("Delete this project") {
                    self.showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
                .alert(isPresented: $showingDeleteConfirm) {
                    Alert(title: Text("Delete project?"),
                          message: Text("Are you sure?"),
                          primaryButton: .default(Text("Delete"), action: delete), secondaryButton: .cancel())
                }
            }
        }
        .navigationTitle("Edit Project")
        .toolbar {
            switch cloudStatus {
                case .checking:
                    ProgressView()
                case .exists:
                    Button {
                        self.removeFromCloud(deleteLocal: false)
                    } label: {
                        Label("Remove from iCloud", systemImage: "icloud.slash")
                    }
                case .absent:
                    Button(action: uploadToCloud) {
                        Label("Upload to iCloud", systemImage: "icloud.and.arrow.up")
                    }
            }
        }
        .onAppear(perform: updateCloudStatus)
        .onDisappear(perform: self.dataController.save)
        .alert(item: $cloudError) { error in
            Alert(
                title: Text("There was an error"),
                message: Text(error.localizedMessage)
            )
        }
        .sheet(isPresented: $showingSignIn, content: SignInView.init)
    }

    func updateCloudStatus() {
        project.checkCloudStatus { exists in
            if exists {
                cloudStatus = .exists
            } else {
                cloudStatus = .absent
            }
        }
    }

    func removeFromCloud(deleteLocal: Bool) {
        let name = project.objectID.uriRepresentation().absoluteString
        let id = CKRecord.ID(recordName: name)

        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [id])

        operation.modifyRecordsCompletionBlock = { _, _, error in
            if let error = error {
                cloudError = error.getCloudKitError()
            } else {
                if deleteLocal {
                    dataController.delete(project)
                    presentationMode.wrappedValue.dismiss()
                }
            }

            updateCloudStatus()
        }
        cloudStatus = .checking
        CKContainer.default().publicCloudDatabase.add(operation)
    }

    func uploadToCloud() {
        if let username = username {
            let records = project.prepareCloudRecords(owner: username)
            let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
            operation.savePolicy = .allKeys
            operation.modifyRecordsCompletionBlock = { _, _, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }

            operation.modifyRecordsCompletionBlock = { _, _, _ in
                updateCloudStatus()
            }
            cloudStatus = .checking

            CKContainer.default().publicCloudDatabase.add(operation)
        } else {
            showingSignIn = true
        }
    }

    func colorButton(for colorName: String) -> some View {
        ZStack {
            Color(colorName)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if colorName == color {
                SFSymbol.checkmarkCircle
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = colorName
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            colorName == color ? [.isButton, .isSelected] : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(colorName))
    }

    #if os(iOS)
    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
    #endif

    func update() {
        self.project.title = self.title
        self.project.detail = self.detail
        self.project.color = self.color
        if remindMe {
            self.project.reminderTime = reminderTime
            dataController.addReminders(for: project) { success in
                if success == false {
                    project.reminderTime = nil
                    remindMe = false
                    showingNotificationError = true
                }
            }
        } else {
            self.project.reminderTime = nil
            dataController.removeReminders(for: project)
        }
    }

    func delete() {
        if cloudStatus == .exists {
            removeFromCloud(deleteLocal: true) // this sort of works. what if user is offline
        } else {
            self.dataController.delete(self.project)
            self.presentationMode.wrappedValue.dismiss()
        }
    }

    func toggleClosed() {
        self.project.closed.toggle()
        if project.closed {
            // trigger haptics
            do {
                try self.hapticEngine?
                    .start()
                // Play with these settings to see the differences
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
                let intenstity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
                let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
                let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)
                let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, end], relativeTime: 0)
                let event1 = CHHapticEvent(eventType: .hapticTransient, parameters: [intenstity, sharpness], relativeTime: 0)
                let event2 = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intenstity], relativeTime: 0.125, duration: 1)
                let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])

                let player = try hapticEngine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                // playing haptics didn't work
                print(error.localizedDescription)
            }
        }
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
