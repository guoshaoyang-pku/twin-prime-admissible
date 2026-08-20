import Sound
import lean_certs.cert_47_200

open CertVerify

theorem H47_gt_200 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 200 := by
  exact certValidRoot_sound (k := 47) (d := 200) (c := cert_47_200) (by native_decide)
