import Sound
import lean_certs.cert_39_168

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_168_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 39) (d := 168) (c := cert_39_168) (by decide)
