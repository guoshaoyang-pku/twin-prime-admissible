import Sound
import lean_certs.cert_33_132

open CertVerify

theorem H33_gt_132 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 33) (d := 132) (c := cert_33_132) (by native_decide)
