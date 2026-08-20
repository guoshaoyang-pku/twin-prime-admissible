import Sound
import lean_certs.cert_36_138

open CertVerify

theorem H36_gt_138 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 36) (d := 138) (c := cert_36_138) (by native_decide)
