import Sound
import lean_certs.cert_47_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_110_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 47) (d := 110) (c := cert_47_110) (by decide)
