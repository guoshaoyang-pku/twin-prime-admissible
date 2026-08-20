import Sound
import lean_certs.cert_47_162

open CertVerify

theorem H47_gt_162 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 47) (d := 162) (c := cert_47_162) (by native_decide)
