import Sound
import lean_certs.cert_47_126

open CertVerify

theorem H47_gt_126 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 47) (d := 126) (c := cert_47_126) (by native_decide)
