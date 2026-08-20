import Sound
import lean_certs.cert_49_126

open CertVerify

theorem H49_gt_126 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 49) (d := 126) (c := cert_49_126) (by native_decide)
