import Sound
import lean_certs.cert_26_100

open CertVerify

theorem H26_gt_100 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 26) (d := 100) (c := cert_26_100) (by native_decide)
