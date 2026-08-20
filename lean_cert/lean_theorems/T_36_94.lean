import Sound
import lean_certs.cert_36_94

open CertVerify

theorem H36_gt_94 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 36) (d := 94) (c := cert_36_94) (by native_decide)
