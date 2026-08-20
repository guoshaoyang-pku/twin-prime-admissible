import Sound
import lean_certs.cert_47_184

open CertVerify

theorem H47_gt_184 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 47) (d := 184) (c := cert_47_184) (by native_decide)
