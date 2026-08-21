import Sound
import lean_certs.cert_38_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_110_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 38) (d := 110) (c := cert_38_110) (by decide)
