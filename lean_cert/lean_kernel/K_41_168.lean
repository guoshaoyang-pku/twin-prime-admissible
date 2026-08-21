import Sound
import lean_certs.cert_41_168

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_168_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 41) (d := 168) (c := cert_41_168) (by decide)
