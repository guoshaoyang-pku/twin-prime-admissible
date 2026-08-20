import Sound
import lean_certs.cert_33_126

open CertVerify

theorem H33_gt_126 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 33) (d := 126) (c := cert_33_126) (by native_decide)
