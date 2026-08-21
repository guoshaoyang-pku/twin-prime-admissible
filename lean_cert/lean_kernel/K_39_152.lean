import Sound
import lean_certs.cert_39_152

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_152_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 39) (d := 152) (c := cert_39_152) (by decide)
