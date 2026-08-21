import Sound
import lean_certs.cert_18_64

open CertVerify

theorem H18_gt_64 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 18) (d := 64) (c := cert_18_64) (by native_decide)
