import Sound
import lean_certs.cert_30_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_110_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 30) (d := 110) (c := cert_30_110) (by decide)
