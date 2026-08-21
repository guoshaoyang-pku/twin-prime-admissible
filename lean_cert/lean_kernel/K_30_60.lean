import Sound
import lean_certs.cert_30_60

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_60_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 30) (d := 60) (c := cert_30_60) (by decide)
