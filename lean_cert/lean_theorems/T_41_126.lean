import Sound
import lean_certs.cert_41_126

open CertVerify

theorem H41_gt_126 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 41) (d := 126) (c := cert_41_126) (by native_decide)
