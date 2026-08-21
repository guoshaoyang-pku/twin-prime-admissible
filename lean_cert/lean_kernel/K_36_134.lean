import Sound
import lean_certs.cert_36_134

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_134_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 36) (d := 134) (c := cert_36_134) (by decide)
