import Sound
import lean_certs.cert_40_126

open CertVerify

theorem H40_gt_126 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 40) (d := 126) (c := cert_40_126) (by native_decide)
