import Sound
import lean_certs.cert_32_126

open CertVerify

theorem H32_gt_126 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 32) (d := 126) (c := cert_32_126) (by native_decide)
