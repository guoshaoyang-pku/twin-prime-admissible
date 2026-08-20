import Sound
import lean_certs.cert_47_190

open CertVerify

theorem H47_gt_190 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 190 := by
  exact certValidRoot_sound (k := 47) (d := 190) (c := cert_47_190) (by native_decide)
