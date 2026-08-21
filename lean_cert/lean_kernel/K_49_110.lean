import Sound
import lean_certs.cert_49_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_110_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 49) (d := 110) (c := cert_49_110) (by decide)
