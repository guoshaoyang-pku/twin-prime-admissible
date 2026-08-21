import Sound
import lean_certs.cert_39_164

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_164_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 39) (d := 164) (c := cert_39_164) (by decide)
