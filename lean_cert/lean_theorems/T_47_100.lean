import Sound
import lean_certs.cert_47_100

open CertVerify

theorem H47_gt_100 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 47) (d := 100) (c := cert_47_100) (by native_decide)
