import Sound
import lean_certs.cert_47_146

open CertVerify

theorem H47_gt_146 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 47) (d := 146) (c := cert_47_146) (by native_decide)
