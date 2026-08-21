import Sound
import lean_certs.cert_17_62

open CertVerify

theorem H17_gt_62 : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 17) (d := 62) (c := cert_17_62) (by native_decide)
