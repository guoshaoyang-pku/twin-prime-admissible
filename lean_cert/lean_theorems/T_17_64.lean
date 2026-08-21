import Sound
import lean_certs.cert_17_64

open CertVerify

theorem H17_gt_64 : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 17) (d := 64) (c := cert_17_64) (by native_decide)
