import Sound
import lean_certs.cert_35_126

open CertVerify

theorem H35_gt_126 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 35) (d := 126) (c := cert_35_126) (by native_decide)
