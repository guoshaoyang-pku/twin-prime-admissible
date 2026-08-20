import Sound
import lean_certs.cert_39_126

open CertVerify

theorem H39_gt_126 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 39) (d := 126) (c := cert_39_126) (by native_decide)
