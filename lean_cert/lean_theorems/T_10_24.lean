import Sound
import lean_certs.cert_10_24

open CertVerify

theorem H10_gt_24 : ¬ ∃ t : List Nat, admissible 10 t = true ∧ diameter t ≤ 24 := by
  exact certValidRoot_sound (k := 10) (d := 24) (c := cert_10_24) (by native_decide)
