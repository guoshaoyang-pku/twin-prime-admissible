import Sound
import lean_certs.cert_31_126

open CertVerify

theorem H31_gt_126 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 31) (d := 126) (c := cert_31_126) (by native_decide)
