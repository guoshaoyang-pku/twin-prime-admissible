import Sound
import lean_certs.cert_47_200

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_200_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 200 := by
  exact certValidRoot_sound (k := 47) (d := 200) (c := cert_47_200) (by decide)
