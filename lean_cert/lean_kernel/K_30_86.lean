import Sound
import lean_certs.cert_30_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_86_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 30) (d := 86) (c := cert_30_86) (by decide)
