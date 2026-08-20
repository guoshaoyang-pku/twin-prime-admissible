import Sound
import lean_certs.cert_36_158

open CertVerify

theorem H36_gt_158 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 36) (d := 158) (c := cert_36_158) (by native_decide)
