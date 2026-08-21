import Sound
import lean_certs.cert_41_118

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_118_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 41) (d := 118) (c := cert_41_118) (by decide)
