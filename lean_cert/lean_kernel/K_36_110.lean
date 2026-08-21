import Sound
import lean_certs.cert_36_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_110_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 36) (d := 110) (c := cert_36_110) (by decide)
