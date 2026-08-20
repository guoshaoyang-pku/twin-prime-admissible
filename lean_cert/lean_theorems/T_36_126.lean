import Sound
import lean_certs.cert_36_126

open CertVerify

theorem H36_gt_126 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 36) (d := 126) (c := cert_36_126) (by native_decide)
