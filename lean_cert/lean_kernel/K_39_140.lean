import Sound
import lean_certs.cert_39_140

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_140_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 39) (d := 140) (c := cert_39_140) (by decide)
