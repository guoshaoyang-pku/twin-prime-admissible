import Sound
import lean_certs.cert_39_134

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_134_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 39) (d := 134) (c := cert_39_134) (by decide)
