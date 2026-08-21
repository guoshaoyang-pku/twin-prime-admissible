import Sound
import lean_certs.cert_19_64

open CertVerify

theorem H19_gt_64 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 19) (d := 64) (c := cert_19_64) (by native_decide)
