import Sound
import lean_certs.cert_30_64

open CertVerify

theorem H30_gt_64 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 30) (d := 64) (c := cert_30_64) (by native_decide)
