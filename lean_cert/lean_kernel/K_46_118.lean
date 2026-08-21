import Sound
import lean_certs.cert_46_118

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_118_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 46) (d := 118) (c := cert_46_118) (by decide)
