import Sound
import lean_certs.cert_36_72

open CertVerify

theorem H36_gt_72 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 36) (d := 72) (c := cert_36_72) (by native_decide)
