import Sound
import lean_certs.cert_26_64

open CertVerify

theorem H26_gt_64 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 26) (d := 64) (c := cert_26_64) (by native_decide)
