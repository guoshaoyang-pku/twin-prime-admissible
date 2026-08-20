import Sound
import lean_certs.cert_29_126

open CertVerify

theorem H29_gt_126 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 29) (d := 126) (c := cert_29_126) (by native_decide)
