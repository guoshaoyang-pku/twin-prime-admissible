import Sound
import lean_certs.cert_38_126

open CertVerify

theorem H38_gt_126 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 38) (d := 126) (c := cert_38_126) (by native_decide)
