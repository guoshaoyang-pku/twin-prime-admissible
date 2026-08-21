import Sound
import lean_certs.cert_39_118

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_118_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 39) (d := 118) (c := cert_39_118) (by decide)
