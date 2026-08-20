import Sound
import lean_certs.cert_36_84

open CertVerify

theorem H36_gt_84 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 36) (d := 84) (c := cert_36_84) (by native_decide)
