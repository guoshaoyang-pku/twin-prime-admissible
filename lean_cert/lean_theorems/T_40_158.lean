import Sound
import lean_certs.cert_40_158

open CertVerify

theorem H40_gt_158 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 40) (d := 158) (c := cert_40_158) (by native_decide)
