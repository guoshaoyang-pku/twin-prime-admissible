import Sound
import lean_certs.cert_42_126

open CertVerify

theorem H42_gt_126 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 42) (d := 126) (c := cert_42_126) (by native_decide)
