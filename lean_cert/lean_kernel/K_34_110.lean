import Sound
import lean_certs.cert_34_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_110_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 34) (d := 110) (c := cert_34_110) (by decide)
